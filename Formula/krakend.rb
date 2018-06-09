class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "http://www.krakend.io/"
  url "https://github.com/devopsfaith/krakend-ce/archive/0.5.0.tar.gz"
  sha256 "f97485df9f8549517da983df338e013dfe0b0f86db5423285163193267df6fa8"

  bottle do
    cellar :any_skip_relocation
    sha256 "39f85cd1563ea74979935c81df50b438c8c33e20a4a0376e32269f1832551f8e" => :high_sierra
    sha256 "d9622508b0b8fb4c1b9bd203b7faec557386926f5a8d9a2149f4d637976d42f9" => :sierra
    sha256 "0ca60885fc69e612b589bad09f136fc5124a5b52909608b693665211479807a6" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/devopsfaith/krakend-ce").install buildpath.children
    cd "src/github.com/devopsfaith/krakend-ce" do
      system "make", "deps"
      system "make", "build"
      bin.install "krakend"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"krakend_unsupported_version.json").write <<~EOS
      {
        "version": 1,
        "extra_config": {
          "github_com/devopsfaith/krakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        }
      }
    EOS
    assert_match "Unsupported version", shell_output("#{bin}/krakend check -c krakend_unsupported_version.json 2>&1")

    (testpath/"krakend_bad_file.json").write <<~EOS
      {
        "version": 2,
        "bad": file
      }
    EOS
    assert_match "ERROR", shell_output("#{bin}/krakend check -c krakend_incomplete.json 2>&1")

    (testpath/"krakend.json").write <<~EOS
      {
        "version": 2,
        "extra_config": {
          "github_com/devopsfaith/krakend-gologging": {
            "level": "WARNING",
            "prefix": "[KRAKEND]",
            "syslog": false,
            "stdout": true
          }
        },
        "endpoints": [
          {
            "endpoint": "/test",
            "method": "GET",
            "concurrent_calls": 1,
            "extra_config": {
              "github_com/devopsfaith/krakend-httpsecure": {
                "disable": true,
                "allowed_hosts": [],
                "ssl_proxy_headers": {}
              },
              "github.com/devopsfaith/krakend-ratelimit/juju/router": {
                "maxRate": 0,
                "clientMaxRate": 0
              }
            },
            "backend": [
              {
                "url_pattern": "/backend",
                "extra_config": {
                  "github.com/devopsfaith/krakend-oauth2-clientcredentials": {
                    "is_disabled": true,
                    "endpoint_params": {}
                  }
                },
                "encoding": "json",
                "sd": "dns",
                "host": [
                  "host1"
                ],
                "disable_host_sanitize": true
              }
            ]
          }
        ]
      }
    EOS
    assert_match "OK", shell_output("#{bin}/krakend check -c krakend.json 2>&1")
  end
end
