class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git", :tag => "v20180302",
                                                      :revision => "f3e9e756e182b122bef8826a77047f6ccf5529b6"
  head "https://github.com/cquery-project/cquery.git"

  depends_on "python@2" => :build
  depends_on "xz" => :build

  bottle do
    cellar :any
    rebuild 1
    sha256 "72af8463ffcfc4ead08f894c7481083b96f9354624b97a77bd04c61b4276d73f" => :high_sierra
    sha256 "4ad4f49c895a466e5719853cf2dd6f1802a179e616fca8d416d11cc9fb70955b" => :sierra
    sha256 "feb488e69c97f34528f3d53d6015923c4f56751ae8deb35a3807d356fe6e0d49" => :el_capitan
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end
