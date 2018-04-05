class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.17.0/chapel-1.17.0.tar.gz"
  sha256 "7620b780cf2a2bd3b26022957c3712983519a422a793614426aed6d9d8bf9fab"
  revision 1

  head "https://github.com/chapel-lang/chapel.git"

  bottle do
    sha256 "5cb04d70c05d714f251cb3de9df374c9e220a6aaefb6b2a1c5667eb19c3498ca" => :high_sierra
    sha256 "87ad19c7850b21d8f8cc16c4ecfb7ed3be3af0850940b11ae8ccb18382000f35" => :sierra
    sha256 "23f3cf498ce1c8441a95d8b981295706d21c8f8f07253470fb3e87e13bd5a1dc" => :el_capitan
  end

  depends_on "python@2"

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
      system "make", "test-venv"
      system "make", "cleanall"
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    bin.install Dir[libexec/"bin/darwin/*"]
    bin.env_script_all_files libexec/"bin/darwin/", :CHPL_HOME => libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "make", "check"
    end
  end
end
