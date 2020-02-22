class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=aurora/0.22.0/apache-aurora-0.22.0.tar.gz"
  mirror "https://archive.apache.org/dist/aurora/0.22.0/apache-aurora-0.22.0.tar.gz"
  sha256 "d3c20a09dcc62cac98cb83889099e845ce48a1727ca562d80b9a9274da2cfa12"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1adcb09eadc442515ea2e53145d61dd4922762a291f07a0925e7ca2786a22fea" => :catalina
    sha256 "94cb59c143eff8514376c5a281f3fd5db914d458bb8e70481fb426c38aabab98" => :mojave
    sha256 "cd7f11d19a86813396077ab5f594e30e8b2211b64bb603e0d13359599e3e3b32" => :high_sierra
  end

  depends_on "python"

  def install
    # No pants yet for Mojave, so we force High Sierra binaries there
    ENV["PANTS_BINARIES_PATH_BY_ID"] = "{('darwin','15'):('mac','10.11'),('darwin','16'):('mac','10.12'),('darwin','17'):('mac','10.13'),('darwin','18'):('mac','10.13')}"

    system "./pants", "binary", "src/main/python/apache/aurora/kerberos:kaurora"
    system "./pants", "binary", "src/main/python/apache/aurora/kerberos:kaurora_admin"
    bin.install "dist/kaurora.pex" => "aurora"
    bin.install "dist/kaurora_admin.pex" => "aurora_admin"
  end

  test do
    ENV["AURORA_CONFIG_ROOT"] = "#{testpath}/"
    (testpath/"clusters.json").write <<~EOS
      [{
        "name": "devcluster",
        "slave_root": "/tmp/mesos/",
        "zk": "172.16.64.185",
        "scheduler_zk_path": "/aurora/scheduler",
        "auth_mechanism": "UNAUTHENTICATED"
      }]
    EOS
    system "#{bin}/aurora_admin", "get_cluster_config", "devcluster"
  end
end
