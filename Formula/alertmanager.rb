class Alertmanager < Formula
  desc "Prometheus Alertmanager"
  homepage "https://prometheus.io/docs/alerting/alertmanager/"
  url "https://github.com/prometheus/alertmanager/archive/v0.15.1.tar.gz"
  sha256 "5b36c873b25443b61cc0686e048596737c9d11a3579c39ef9063b3c619595da8"

  bottle do
    cellar :any_skip_relocation
    sha256 "191581b563f695ab19a40aa68bdc74078612aa8e4ad62141a5bd7dc8906d8194" => :high_sierra
    sha256 "992abbcce3c1b3c9e4745d8972f5ee47dab47348beb19c63ccd6e92f2b6ecce6" => :sierra
    sha256 "52517bb24630dd8200ace545aeb53c0fdf7d12c23e61a7d744d300acc1d7776e" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/alertmanager"

    system "make", "build"
    bin.install %w[alertmanager amtool]
  end

  test do
    (testpath/"config.yml").write <<~EOS
      global:
        # The smarthost and SMTP sender used for mail notifications.
        smtp_smarthost: 'localhost:25'
        smtp_from: 'alertmanager@example.org'
        smtp_auth_username: 'alertmanager'
        smtp_auth_password: 'password'

      # The root route on which each incoming alert enters.
      route:
      # A default receiver
        receiver: team-X-mails

      receivers:
      - name: 'team-X-mails'
        email_configs:
        - to: 'team-X+alerts@example.org'
    EOS
    system "#{bin}/amtool", "check-config", testpath/"config.yml"
  end
end
