class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/3.04.01.tar.gz"
  sha256 "57f63e1b14ae04c3932a2683e4be4954a2849e17edd638ffe91bc5a2156adc6a"
  revision 2

  bottle do
    revision 1
    sha256 "54a3ceb638101ef99b176bce1554ae59c48a5bae949b23dd16ac305899e9e324" => :el_capitan
    sha256 "2fc63f5d1ec9fcb7e8c8d751bec16c8646bd94c6dfdf6704d147a0ee2e1ae868" => :yosemite
    sha256 "07e94562cf24eb59c91f76cda029f7994fab603774ec784b3374670f32839e9f" => :mavericks
  end

  head do
    url "https://github.com/tesseract-ocr/tesseract.git"

    depends_on "autoconf" => :build
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

  fails_with :llvm do
    build 2206
    cause "Executable 'tesseract' segfaults on 10.6 when compiled with llvm-gcc"
  end

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
      (pkgshare/"tessdata").install resource("snum")
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
