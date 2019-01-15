class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.7.tar.gz"
  sha256 "2c24359131d7495e47dc95021eb35f1ba408ded9087e36370d94742a4011033c"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    rebuild 2
    sha256 "e5d50045733bed15d7b401ef8807d71694cb93a46e21d55a6f91ea3aec5876dc" => :mojave
    sha256 "09efc12c9d3cb0e945070d4bb4ef2a5eb1e4632f38287ef8ae5ff74158d8d7ac" => :high_sierra
    sha256 "813bf23717bdbe14d8e2cf62d92dffd26ac83b121d80c6f3c965e239b9c4978d" => :sierra
  end

  depends_on "openssl"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    if MacOS.sdk_path_if_needed
      args << "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      args << "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
