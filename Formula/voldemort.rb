class Voldemort < Formula
  desc "Distributed key-value storage system"
  homepage "http://www.project-voldemort.com/"
  url "https://github.com/voldemort/voldemort/archive/release-1.10.25-cutoff.tar.gz"
  sha256 "d5e37d69cbe0cbb3605e0bf424bc2a5a4116fb81fedc481002341fd53cba8efb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0e2507b633acb1ff45f8979f78072647449ecc22be02b1d1e8eba4062e91d1cb" => :sierra
    sha256 "79871f563f3df0db5541ba856931c8a7e0bb1e03bd782915fe5ca35726c8a884" => :el_capitan
    sha256 "2d787c729e3579d9ef322c883d45f2d9e21df10e15636a2aea3c6f649e55d0f1" => :yosemite
  end

  depends_on "gradle" => :build
  depends_on :java => "1.7+"

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
