class Multitail < Formula
  desc "Tail multiple files in one terminal simultaneously"
  homepage "https://vanheusden.com/multitail/"
  url "https://vanheusden.com/multitail/multitail-6.4.2.tgz"
  sha256 "af1d5458a78ad3b747c5eeb135b19bdca281ce414cefdc6ea0cff6d913caa1fd"
  head "https://github.com/flok99/multitail.git"

  bottle do
    rebuild 2
    sha256 "29e45507010c6d9ad5fb9365bed1231d843b970d701ae008521392290feced5c" => :high_sierra
    sha256 "525fb33257cb04f1eef00aabcea75cc09fb20fb657d9e5505898b9856e913440" => :sierra
    sha256 "dea5ac34023d93fcb42de3fb40d1e22d11c37c233f77c52971c7bb87dcefdf40" => :el_capitan
  end

  def install
    system "make", "-f", "makefile.macosx", "multitail", "DESTDIR=#{HOMEBREW_PREFIX}"

    bin.install "multitail"
    man1.install gzip("multitail.1")
    etc.install "multitail.conf"
  end

  test do
    if build.head?
      assert_match "multitail", shell_output("#{bin}/multitail -h 2>&1", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/multitail -h 2>&1", 1)
    end
  end
end
