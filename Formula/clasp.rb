class Clasp < Formula
  desc "Answer set solver for (extended) normal logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/clasp/3.2.0/clasp-3.2.0-source.tar.gz"
  sha256 "eafb050408b586d561cd828aec331b4d3b92ea7a26d249a02c4f39b1675f4e68"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f9bbe59c3ca94fdefdee2dda558c04bdb65ced21c696b02093f5b45fe5b4c215" => :sierra
    sha256 "de2ea966c773ee0446ce91435edf813aff70f84486fe6c88fc64ad0591780aac" => :el_capitan
    sha256 "7d56860973b34f5b3a9fb210792af5aa122af777362df8397e476a00116bdaca" => :yosemite
  end

  option "with-tbb", "Enable multi-thread support"

  deprecated_option "with-mt" => "with-tbb"

  depends_on "tbb" => :optional

  def install
    if build.with? "tbb"
      ENV["TBB30_INSTALL_DIR"] = Formula["tbb"].opt_prefix
      build_dir = "build/release_mt"
    else
      build_dir = "build/release"
    end

    args = %W[
      --config=release
      --prefix=#{prefix}
    ]
    args << "--with-mt=tbb" if build.with? "tbb"

    bin.mkpath
    system "./configure.sh", *args
    system "make", "-C", build_dir, "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clasp --version")
  end
end
