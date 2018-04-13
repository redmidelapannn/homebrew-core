class AuroraCli < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/aurora/0.20.0/apache-aurora-0.20.0.tar.gz"
  sha256 "9b56953ec95922ca332caaeebb0b9c1c9bec82b86bddd46b734782e831a49421"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d9ea319d9a001b60ae50143568af2d07e8b6b46791d1bb09b8b945bff553665" => :high_sierra
    sha256 "4b6557618832667eb85d82623d7168122fb5bfb0cb9d55393d324a532f59dea6" => :sierra
    sha256 "636573d7ad977380bfdc601705f6879b1cc9b0231edeef13d56d7c60f0793dd9" => :el_capitan
  end

  if MacOS.version <= :sierra
    patch do
      url "https://raw.githubusercontent.com/thinker0/aurora/virtualenv-update/pants.diff"
      sha256 "31951bdc046066dd9c1ca730a79f654faddad2fbff3faf9ac2a51f6a6ce0cd0a"
    end
  end

  depends_on "python@2"

  def install
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
