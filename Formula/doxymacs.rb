class Doxymacs < Formula
  desc "Elisp package for using doxygen under Emacs"
  homepage "https://doxymacs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/doxymacs/doxymacs/1.8.0/doxymacs-1.8.0.tar.gz"
  sha256 "a23fd833bc3c21ee5387c62597610941e987f9d4372916f996bf6249cc495afa"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d4aa82a82924ef76c7e795a23d026292ff275ab07cce5a4d805356e31a3b0e6b" => :sierra
    sha256 "5cfc06a11e16fe25fa168742363899d42c760df2608bc883130701025fa0a6ad" => :el_capitan
    sha256 "c975e008e2468118503ddacf848b9ec076a3e157e0b8c838ca48670cad0629cb" => :yosemite
  end

  head do
    url "git://git.code.sf.net/p/doxymacs/code"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :emacs => "20.7.1"
  depends_on "doxygen"

  def install
    # https://sourceforge.net/tracker/?func=detail&aid=3577208&group_id=23584&atid=378985
    ENV.append "CFLAGS", "-std=gnu89"

    # Fix undefined symbol errors for _xmlCheckVersion, etc.
    # This prevents a mismatch between /usr/bin/xml2-config and the SDK headers,
    # which would cause the build system not to pass the LDFLAGS for libxml2.
    ENV.prepend_path "PATH", "#{MacOS.sdk_path}/usr/bin"

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "doxymacs")
      (print doxymacs-version)
    EOS
    output = shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
    assert_equal "\"#{version}\"", output
  end
end
