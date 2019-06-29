class Chezscheme < Formula
  desc "Chez Scheme"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.5.2.tar.gz"
  sha256 "3a370fdf2ffd67d6a0ccbb993dfab1cbaf4a0a97983c869cfaab40528c33c48b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7f47a90f82d2894f39d6d9d6e429c2cf27208da8dec2001f489dec6e77ca1b3e" => :mojave
    sha256 "f349af59c8904e4e2533142bdc4dcf9a727b96182a996925d87b5aacebf533bf" => :high_sierra
    sha256 "052b29f8f72d32b31054533d9742389819fa4e811496773df0025daa82f40918" => :sierra
  end

  depends_on :x11 => :build
  uses_from_macos "ncurses"

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Feb 2017 https://github.com/cisco/ChezScheme/issues/146
    if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"
      inreplace "c/stats.c" do |s|
        s.gsub! "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_PROCESS_CPUTIME_ID", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_REALTIME", "UNDEFINED_GIBBERISH"
        s.gsub! "CLOCK_THREAD_CPUTIME_ID", "UNDEFINED_GIBBERISH"
      end
    end

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
