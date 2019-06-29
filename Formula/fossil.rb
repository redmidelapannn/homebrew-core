class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.8.tar.gz"
  sha256 "6a32bec73de26ff5cc8bbb0b7b45360f4e4145931fd215ed91414ed190b3715d"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    rebuild 1
    sha256 "9158f364a9b36ca1fcd592350e94443551ab218923fda42e9f6c2e132c03ccaf" => :mojave
    sha256 "df2cb5157114253bb7c15a3d10c6d462128e86dfe38ce4ccbe7239c0640b13c1" => :high_sierra
    sha256 "5fb84829fdbcef54a0de7ce3321cc69ffc102fcfa1b2a1604356f0f1af4782a1" => :sierra
  end

  depends_on "openssl"
  uses_from_macos "zlib"

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
