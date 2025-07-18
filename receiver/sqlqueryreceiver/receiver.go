// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0

package sqlqueryreceiver // import "github.com/open-telemetry/opentelemetry-collector-contrib/receiver/sqlqueryreceiver"

import (
	"context"
	"fmt"

	"go.opentelemetry.io/collector/component"
	"go.opentelemetry.io/collector/consumer"
	"go.opentelemetry.io/collector/pdata/pcommon"
	"go.opentelemetry.io/collector/receiver"
	"go.opentelemetry.io/collector/scraper/scraperhelper"

	"github.com/open-telemetry/opentelemetry-collector-contrib/internal/sqlquery"
	"github.com/open-telemetry/opentelemetry-collector-contrib/receiver/sqlqueryreceiver/internal"
	"github.com/open-telemetry/opentelemetry-collector-contrib/receiver/sqlqueryreceiver/internal/metadata"
)

func createLogsReceiverFunc(sqlOpenerFunc sqlquery.SQLOpenerFunc, clientProviderFunc sqlquery.ClientProviderFunc) receiver.CreateLogsFunc {
	return func(
		_ context.Context,
		settings receiver.Settings,
		cfg component.Config,
		consumer consumer.Logs,
	) (receiver.Logs, error) {
		sqlQueryConfig := cfg.(*Config)
		return newLogsReceiver(sqlQueryConfig, settings, sqlOpenerFunc, clientProviderFunc, consumer)
	}
}

func createMetricsReceiverFunc(sqlOpenerFunc sqlquery.SQLOpenerFunc, clientProviderFunc sqlquery.ClientProviderFunc) receiver.CreateMetricsFunc {
	return func(
		_ context.Context,
		settings receiver.Settings,
		cfg component.Config,
		consumer consumer.Metrics,
	) (receiver.Metrics, error) {
		sqlCfg := cfg.(*Config)
		var dataSource string
		var err error

		if sqlCfg.DataSource != "" {
			dataSource = sqlCfg.DataSource
		} else {
			dataSource, err = sqlquery.BuildDataSourceString(sqlCfg.Config)
			if err != nil {
				return nil, err
			}
		}
		var opts []scraperhelper.ControllerOption
		pool := internal.NewPool(sqlOpenerFunc, sqlCfg.Driver, dataSource, sqlCfg.MaxOpenConn)

		for i, query := range sqlCfg.Queries {
			if len(query.Metrics) == 0 {
				continue
			}
			id := component.MustNewIDWithName("sqlqueryreceiver", fmt.Sprintf("query-%d: %s", i, query.SQL))

			scope := pcommon.NewInstrumentationScope()
			scope.SetName(metadata.ScopeName)
			mp := sqlquery.NewScraper(id, query, sqlCfg.ControllerConfig, settings.Logger, sqlCfg.Telemetry, pool.DB, clientProviderFunc, scope)

			opt := scraperhelper.AddScraper(metadata.Type, mp)
			opts = append(opts, opt)
		}

		return scraperhelper.NewMetricsController(
			&sqlCfg.ControllerConfig,
			settings,
			consumer,
			opts...,
		)
	}
}
