class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.9.1.tar.gz"
  sha256 "fedf979c53da9cdea9af637ecd7da097a0e0cd22642e5491c891a341a3365260"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fb3425677d04186be6be6f3b1abb39e03073dcfb04391b66798a5a779351cc97" => :high_sierra
    sha256 "3993d9e049d73d26b55e5b934260824af21b833d44757b1a18f0b7f4f0b572ae" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "--help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
