class Normalize < Formula
  desc "Adjust volume of audio files to a standard level"
  homepage "https://www.nongnu.org/normalize/"
  url "https://savannah.nongnu.org/download/normalize/normalize-0.7.7.tar.gz"
  sha256 "6055a2abccc64296e1c38f9652f2056d3a3c096538e164b8b9526e10b486b3d8"

  bottle do
    cellar :any
    rebuild 2
    sha256 "1af3261bc843e0e368977d805e399efee86811479eae56e6b2a19a3b08f2241b" => :mojave
    sha256 "9aba16c020eacae44dda68962add016d6b06558b3ababeea6bfdb2c9c5cd95de" => :high_sierra
    sha256 "769e1ad6eb9e99bcae3079501dc130b33eb80ab5b15adc4376ada810a05de376" => :sierra
    sha256 "555af40a81491396bccca1e03ad6a20dbfe475d9768a2cd9c299b1028ca7ea42" => :el_capitan
  end

  depends_on "mad"

  conflicts_with "num-utils", :because => "both install `normalize` binaries"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/normalize", "test.mp3"
  end
end
