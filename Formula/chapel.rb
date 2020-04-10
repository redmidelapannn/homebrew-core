class Chapel < Formula
  desc "Emerging programming language designed for parallel computing"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.21.0/chapel-1.21.0.tar.gz"
  sha256 "886f7ba0e0e86c86dba99417e3165f90b1d3eca59c8cd5a7f645ce28cb5d82a0"

  bottle do
    sha256 "67429811aff30704bfad5e7e2225ae3491608c11232f253d76f5c066e1f64ee2" => :catalina
    sha256 "9def6459a6dab6ecb693a022552c7c71c510bb4c3dc89a7e7d2588c5609ff631" => :mojave
    sha256 "64837e9c1af7ed6001db3269dc02a8713bfbb39d77fd554cef3a0ec05eacb655" => :high_sierra
  end

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    # This is for mason
    ENV["CHPL_REGEXP"] = "re2"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "make"
      system "make", "chpldoc"
      system "make", "test-venv"
      system "make", "mason"
      system "make", "cleanall"
    end

    prefix.install_metafiles

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    bin.install Dir[libexec/"bin/darwin-x86_64/*"]
    bin.env_script_all_files libexec/"bin/darwin-x86_64/", :CHPL_HOME => libexec
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
  end

  test do
    ENV["CHPL_HOME"] = libexec
    cd libexec do
      system "make", "check"
    end
  end
end
