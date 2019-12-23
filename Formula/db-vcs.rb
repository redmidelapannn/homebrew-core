class DbVcs < Formula
  desc "Version control for MySQL databases"
  homepage "https://github.com/infostreams/db"
  url "https://github.com/infostreams/db/archive/1.0.tar.gz"
  sha256 "a21f717ead07058242f28d90bd3d56f478f05039f0628e8f177c4383c36efefd"

  bottle do
    cellar :any_skip_relocation
    sha256 "391c0ba55f4838b55a569b02e26e5bd02f6fbc148d9a3220e2f512721e78c5c9" => :catalina
    sha256 "391c0ba55f4838b55a569b02e26e5bd02f6fbc148d9a3220e2f512721e78c5c9" => :mojave
    sha256 "391c0ba55f4838b55a569b02e26e5bd02f6fbc148d9a3220e2f512721e78c5c9" => :high_sierra
  end

  def install
    libexec.install "db"
    libexec.install "bin/"
    bin.install_symlink libexec/"db"
  end

  test do
    assert_equal "fatal: Not a db repository (or any of the parent directories). Please run 'db init'.", shell_output("#{bin}/db server add localhost", 2).strip
  end
end
