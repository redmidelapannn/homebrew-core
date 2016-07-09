class Sqlitebrowser < Formula
  desc "Visual tool to create, design, and edit SQLite databases"
  homepage "http://sqlitebrowser.org"
  url "https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.8.0.tar.gz"
  sha256 "f638a751bccde4bf0305a75685e2a72d26fc3e3a69d7e15fd84573f88c1a4d92"

  head "https://github.com/sqlitebrowser/sqlitebrowser.git"

  bottle do
    cellar :any
    revision 1
    sha256 "10dce18fe482aa3bb766fbdf54ed6186665f342b4fd351d72af03cd84b4e05a3" => :el_capitan
    sha256 "3743ee5ecf2e6fc31b02952a58ed48c94b77116e0721e965e7216460d3e9a3e2" => :yosemite
    sha256 "e9456a76e3e43c6b43bfaef8850ccb98f58e463f0a40e77d17ae7ee681c385c3" => :mavericks
  end

  depends_on "qt5"
  depends_on "cmake" => :build
  depends_on "sqlite" => "with-functions"

  def install
    system "cmake", ".", "-DUSE_QT5=TRUE", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/sqlitebrowser", "-h"
  end
end
