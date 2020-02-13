class Mint < Formula
  desc "Dependency manager that installs and runs Swift command-line tool packages"
  homepage "https://github.com/yonaskolb/Mint"
  url "https://github.com/yonaskolb/Mint/archive/0.14.0.tar.gz"
  sha256 "ebb734858c4acbdf1fc9d27c6dc374b3adc415387dfe76b19d63a7b5dbcae4dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ef70b4bea2c79c1007d4f1b07fe09209db076ac3146f19f002bffac15d04cc5" => :catalina
    sha256 "0205d8c16debb7c8a05b742e9ecf1c8a26bdd28a9e1da5aaa09adce0cd21c403" => :mojave
  end

  depends_on :xcode => ["10.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test by showing the help scree
    system "#{bin}/mint", "help"
    # Test showing list of installed tools
    system "#{bin}/mint", "list"
  end
end
