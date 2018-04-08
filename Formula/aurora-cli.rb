class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.19.0/apache-aurora-0.19.0.tar.gz"
  sha256 "d89ce4b67e4387b479493acb13c346cb53c2369ed33e60ea0f697135d4126c29"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "755ad72b911030c21d2954ffea1d91b2c90533f23e52637071da7b609cf031f9" => :high_sierra
    sha256 "eedf8fa86c17a69939e8d4b01969da1431300d44d61e29a168b1680ef2220bca" => :sierra
    sha256 "275cb696ab2f32023afbf1e369b011d0a20e13cd7f6271910e01e728ef123c7e" => :el_capitan
  end

  if MacOS.version == :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/21a7e7d/aurora-cli/pants_version_1.4.0_dev20.diff"
      sha256 "0f4e3dcab78974d43ff5225df68969609587656313f8e495908523f89f6cb0a7"
    end
  end

  depends_on "python@2"

  def install
    system "./build-support/thrift/prepare_binary.sh"
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
