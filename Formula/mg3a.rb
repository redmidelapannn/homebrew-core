class Mg3a < Formula
  desc "Small Emacs-like editor inspired by mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.160917.tar.gz"
  sha256 "fece7142d7eb6ba4af74783734ec6847d30dcad9c2069602ca4687553a2340ec"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "75e46ec3f7856ad6e8e3cf75ece1110cb64405a287713585fee18b59cdc35d26" => :el_capitan
    sha256 "42e15b731f04246554d552896d733f8085ce0109ce0b6d919e4550a05520d1e7" => :yosemite
  end

  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "with-most", "Include c-like and python modes, user modes and user macros"
  option "with-all", "Include all fancy stuff"

  conflicts_with "mg", :because => "both install `mg`"

  def install
    if build.with?("all")
      mg3aopts = %w[-DALL]
    else
      mg3aopts = %w[-DDIRED -DPREFIXREGION -DUSER_MODES -DUSER_MACROS]
      mg3aopts << "-DLANGMODE_C" if build.with?("c-mode")
      mg3aopts << "-DLANGMODE_PYTHON" if build.with?("python-mode") || build.with?("most")
      mg3aopts << "-DLANGMODE_CLIKE" if build.with?("clike-mode") || build.with?("most")
    end

    system "make", "CDEFS=#{mg3aopts * " "}", "LIBS=-lncurses", "COPT=-O3"
    bin.install "mg"
    doc.install Dir["bl/dot.*"]
    doc.install Dir["README*"]
  end

  test do
    (testpath/"command.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    (testpath/"command.sh").chmod 0755

    system testpath/"command.sh"
  end
end
