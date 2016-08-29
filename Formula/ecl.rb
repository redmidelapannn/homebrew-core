class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.2.tgz"
  sha256 "2d482b1a0a4fbd5d881434517032279d808cb6405e22dd91ef6d733534464b99"

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    rebuild 1
    sha256 "57e195d00cbf9393a108754e0ee07e32b61a674548b3489288617ea158692c5d" => :el_capitan
    sha256 "94f95130470efbc1c909d995465cf3603e215fae79c3149fadd8df326ca060f0" => :yosemite
    sha256 "beb34262e8cd2954b015c40b7cd311f468e1938fd926be009d5c5aabbeec7e4e" => :mavericks
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--with-system-gmp=yes"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
