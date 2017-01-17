class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/3.04.01.tar.gz"
  sha256 "57f63e1b14ae04c3932a2683e4be4954a2849e17edd638ffe91bc5a2156adc6a"
  revision 2

  bottle do
    rebuild 1
    sha256 "6212f3d47b670abb5485424e59aad75b7ca8dcad9806716854c64eecc187f1cd" => :sierra
    sha256 "cb2a1be3016f32431515a6ce5895f013d44ffb8d33a7892a0c7716fc10dc8d6c" => :el_capitan
    sha256 "cc199980af9759cac616bb2e9b9e6e82ab9248e344a1bd11bade4d38d59b5eb1" => :yosemite
  end

  head do
    url "https://github.com/tesseract-ocr/tesseract.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build

    resource "tessdata-head" do
      url "https://github.com/tesseract-ocr/tessdata.git"
    end
  end

  option "with-all-languages", "Install recognition data for all languages"
  option "with-training-tools", "Install OCR training tools"
  option "with-opencl", "Enable OpenCL support"
  option "with-serial-num-pack", "Install serial number recognition pack"

  deprecated_option "all-languages" => "with-all-languages"

  depends_on "leptonica"
  depends_on "libtiff" => :recommended

  if build.with? "training-tools"
    depends_on "libtool" => :build
    depends_on "icu4c"
    depends_on "glib"
    depends_on "cairo"
    depends_on "pango"
    depends_on :x11
  end

  needs :cxx11

  resource "tessdata" do
    url "https://github.com/tesseract-ocr/tessdata/archive/3.04.00.tar.gz"
    sha256 "5dcb37198336b6953843b461ee535df1401b41008d550fc9e43d0edabca7adb1"
  end

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata/raw/3.04.00/eng.traineddata"
    sha256 "c0515c9f1e0c79e1069fcc05c2b2f6a6841fb5e1082d695db160333c1154f06d"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata/raw/3.04.00/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "snum" do
    url "https://github.com/USCDataScience/counterfeit-electronics-tesseract/raw/319a6eeacff181dad5c02f3e7a3aff804eaadeca/Training%20Tesseract/snum.traineddata"
    sha256 "36f772980ff17c66a767f584a0d80bf2302a1afa585c01a226c1863afcea1392"
  end

  def install
    if build.head?
      # ld: symbol(s) not found for _clSetKernelArg and other symbols
      # Regression caused by https://github.com/tesseract-ocr/tesseract/commit/b1c921b
      # Reported 13 Sep 2016 https://github.com/tesseract-ocr/tesseract/issues/426
      inreplace "api/Makefile.am", "$(GENERIC_LIBRARY_VERSION) -no-undefined",
                                   "$(GENERIC_LIBRARY_VERSION)"
    end

    if build.with? "training-tools"
      icu4c = Formula["icu4c"]
      ENV.append "CFLAGS", "-I#{icu4c.opt_include}"
      ENV.append "LDFLAGS", "-L#{icu4c.opt_lib}"
    end

    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    ENV.cxx11

    # Fix broken pkg-config file
    # Can be removed with next version bump
    # https://github.com/tesseract-ocr/tesseract/issues/241
    inreplace "tesseract.pc.in", "@OPENCL_LIB@", "@OPENCL_LDFLAGS@" if build.stable?

    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-opencl" if build.with? "opencl"
    system "./configure", *args

    system "make", "install"
    if build.with? "serial-num-pack"
      resource("snum").stage { mv "snum.traineddata", share/"tessdata" }
    end
    if build.with? "training-tools"
      system "make", "training"
      system "make", "training-install"
    end
    if build.head?
      resource("tessdata-head").stage { mv Dir["*"], share/"tessdata" }
    elsif build.with? "all-languages"
      resource("tessdata").stage { mv Dir["*"], share/"tessdata" }
    else
      resource("eng").stage { mv "eng.traineddata", share/"tessdata" }
      resource("osd").stage { mv "osd.traineddata", share/"tessdata" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tesseract -v 2>&1")
  end
end
