//module github.com/open-telemetry/opentelemetry-collector-contrib/pkg/translator/azure

go 1.23.0

require (
	github.com/json-iterator/go v1.1.12
	github.com/open-telemetry/opentelemetry-collector-contrib/pkg/pdatatest v0.130.0
	github.com/relvacode/iso8601 v1.6.0
	github.com/stretchr/testify v1.10.0
	go.opentelemetry.io/collector/component v1.36.2-0.20250725192953-424a12102dca
	go.opentelemetry.io/collector/pdata v1.36.2-0.20250725192953-424a12102dca
	go.opentelemetry.io/otel v1.37.0
	go.uber.org/goleak v1.3.0
	go.uber.org/zap v1.27.0
	golang.org/x/exp v0.0.0-20240506185415-9bf2ced13842
)

require (
	github.com/cespare/xxhash/v2 v2.3.0 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/go-logr/logr v1.4.3 // indirect
	github.com/go-logr/stdr v1.2.2 // indirect
	github.com/gogo/protobuf v1.3.2 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/hashicorp/go-version v1.7.0 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.3-0.20250322232337-35a7c28c31ee // indirect
	github.com/open-telemetry/opentelemetry-collector-contrib/pkg/pdatautil v0.130.0 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	go.opentelemetry.io/auto/sdk v1.1.0 // indirect
	go.opentelemetry.io/collector/featuregate v1.36.2-0.20250725192953-424a12102dca // indirect
	go.opentelemetry.io/collector/internal/telemetry v0.130.2-0.20250725192953-424a12102dca // indirect
	go.opentelemetry.io/contrib/bridges/otelzap v0.12.0 // indirect
	go.opentelemetry.io/otel/log v0.13.0 // indirect
	go.opentelemetry.io/otel/metric v1.37.0 // indirect
	go.opentelemetry.io/otel/sdk v1.37.0 // indirect
	go.opentelemetry.io/otel/trace v1.37.0 // indirect
	go.uber.org/multierr v1.11.0 // indirect
	golang.org/x/net v0.40.0 // indirect
	golang.org/x/sys v0.33.0 // indirect
	golang.org/x/text v0.25.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20250528174236-200df99c418a // indirect
	google.golang.org/grpc v1.74.2 // indirect
	google.golang.org/protobuf v1.36.6 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

replace github.com/open-telemetry/opentelemetry-collector-contrib/pkg/pdatautil => ../../pdatautil

replace github.com/open-telemetry/opentelemetry-collector-contrib/pkg/pdatatest => ../../pdatatest

module github.com/open-telemetry/opentelemetry-collector-contrib/pkg/translator/azure

replace github.com/open-telemetry/opentelemetry-collector-contrib/pkg/golden => ../../golden
