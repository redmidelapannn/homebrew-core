
class Mg3a < Formula
  desc "Small Emacs-like editor inspired by mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"

  url "https://github.com/paaguti/mg3a/archive/20171130.tar.gz"
  sha256 "03b147806b184b79ffbbabe4b870225bce24c681b3d1e955f22e1c78d9b82885"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb9e89fb2c5447449812ea2862ef960431a6b5270afbf930a0c9f3367ed5b34a" => :high_sierra
    sha256 "3f604a0a29f9baa92a5226865fa5fc52527f9746a5783070cf5dbd0425015127" => :sierra
    sha256 "5821c1e8b6434713d58335e0ec62636f725db6cedf4ac385e548d8a3a488cee4" => :el_capitan
  end

  option "with-all",  "Include all fancy stuff"
  option "with-most", "Include a powerful subset"

  conflicts_with "mg", :because => "both install `mg`"

  patch do
    url "https://raw.githubusercontent.com/paaguti/mg3a/23e0baa6cda2fa8e94fde0778e781f5727a08cc0/debian/patches/02-Makefile.bsd"
    sha256 "d040cd15d86bb34382023ae3cf85a33770585baebb13a3d91b100a72f46e890b"
  end

  patch do
    url "https://raw.githubusercontent.com/paaguti/mg3a/23e0baa6cda2fa8e94fde0778e781f5727a08cc0/debian/patches/01-pipein.diff"
    sha256 "e7cbf41772d9f748bc54978846342d1309bc35810cf6a2b73d4dce4b9c501a5b"
  end

  def install
    if build.with?("all")
      mg3aopts = %w[-DALL]
    else
      mg3aopts = %w[-DDIRED -DPREFIXREGION -DSEARCHALL -DPIPEIN -DUSER_MODES -DUSER_MACROS -DLANGMODE_PYTHON -DLANGMODE_CLIKE]
    end

    system "make", "CDEFS=#{mg3aopts * " "}", "LIBS=-lncurses", "COPT=-O3"
    bin.install "mg"
    doc.install Dir["bl/dot.*"]
    doc.install Dir["README*"]
  end

  test do
    (testpath/"command.sh").write <<~EOS
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
