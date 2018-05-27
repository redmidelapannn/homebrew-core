class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "https://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.25-cutoff.tar.gz"
  sha256 "29f21adee7c8c67c57dacef5c204ceb3c92132dac32d0577418bcd2c5cfb81d2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6f77b28a52967b508c45480510d582b24cddff90ce89941244227b8440691e72" => :high_sierra
    sha256 "444365c89afcd44572535b39f0fc5291a52140e9f42f4ffc132ecbd959a3f5e4" => :sierra
    sha256 "1db94bae8ed387e86f6c46e5976cdd70e430683e2ceee8dd8b8f0c8609bbce83" => :el_capitan
  end

  depends_on "gradle" => :build
  depends_on :java => "1.8"

  def install
    system "./gradlew", "build", "-x", "test"
    libexec.install %w[lib dist contrib]
    bin.install Dir["bin/*{.sh,.py}"]
    libexec.install "bin"
    pkgshare.install "config" => "config-examples"
    (etc/"voldemort").mkpath
    env = {
      :VOLDEMORT_HOME => libexec,
      :VOLDEMORT_CONFIG_DIR => etc/"voldemort",
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system bin/"vadmin.sh"
  end
end
