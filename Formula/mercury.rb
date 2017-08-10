class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-14.01.1.tar.gz"
  sha256 "98f7cbde7a7425365400feef3e69f1d6a848b25dc56ba959050523d546c4e88b"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "c11469c8e9536c4425113002021cb9599d5f923866bc77fe3cf2f947a3cd3401" => :sierra
    sha256 "e073335d7137202741fed612d87854c9e6bf7abcf7943f1596c068c734fd124e" => :el_capitan
    sha256 "3fa8dd33cfe3b3bf93e54b79675dda0686075449e49401701372aa67b5f621c3" => :yosemite
  end

  depends_on "erlang" => :optional
  depends_on "hwloc" => :optional
  depends_on "mono" => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}",
            "--disable-dependency-tracking",
            "--enable-java-grade"]

    args << "--enable-erlang-grade" if build.with? "erlang"
    args << "--with-hwloc" if build.with? "hwloc"
    args << "--enable-csharp-grade" if build.with? "mono"

    system "./configure", *args

    # The build system doesn't quite honour the mandir/infodir autoconf
    # parameters.
    system "make", "install", "PARALLEL=-j",
                              "INSTALL_MAN_DIR=#{man}",
                              "INSTALL_INFO_DIR=#{info}"

    # Remove batch files for windows.
    rm Dir.glob("#{bin}/*.bat")
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.m"
    path.write <<-EOS
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    EOS
    system "#{bin}/mmc", "--make", "hello"
    assert File.exist?(testpath/"hello")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
