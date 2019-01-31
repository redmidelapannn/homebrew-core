class GambitScheme < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.2.tar.gz"
  sha256 "237aa7c4b4e020d7fdc70481aab54dbe3d72e7551a490ae93b2bc45d4638688b"

  bottle do
    sha256 "03c1c5fb7a51938b0ceb7fe6bec144e2bfde05a7830407b10beda3cba362c1f3" => :mojave
    sha256 "0741bdbc2d20a4f0ec4d1ea899c4c9652ebf7fee07df4d4e7f2a5b0ec5790aad" => :high_sierra
    sha256 "8c571925f1dd6513b7481b9d6e0c057e1c108d2e358836f8c2761108a4856449" => :sierra
  end

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-poll
      --enable-openssl
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats; <<~EOS
    Due to conflicts with other packages. (gsi from ghostscript)
    Please ensure to add /usr/local/opt/gambit-scheme-ssl/current/bin to your PATH.
  EOS
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
