class Cmigemo < Formula
  desc "Migemo is a tool that supports Japanese incremental search with Romaji"
  homepage "https://www.kaoriya.net/software/cmigemo"
  head "https://github.com/koron/cmigemo.git"

  stable do
    url "https://cmigemo.googlecode.com/files/cmigemo-default-src-20110227.zip"
    sha256 "4aa759b2e055ef3c3fbeb9e92f7f0aacc1fd1f8602fdd2f122719793ee14414c"

    # Patch per discussion at: https://github.com/Homebrew/homebrew/pull/7005
    patch :DATA
  end
  bottle do
    cellar :any
    revision 1
    sha256 "05aea655134cc11e585bc3fb049cdeb7d507c60b3f1dde74b5eeb93ab57af4a4" => :el_capitan
    sha256 "bdf2d471476b0f7196628cb25bdd9fa15993c3520131481020e80a7f077c3aa2" => :yosemite
    sha256 "6ec0e5d2d59590127d6ef57ada9c8689ac4544c22dd5bee42b1692482850c767" => :mavericks
  end

  depends_on "nkf" => :build

  def install
    chmod 0755, "./configure"
    system "./configure", "--prefix=#{prefix}"
    system "make", "osx"
    system "make", "osx-dict"
    system "make", "-C", "dict", "utf-8" if build.stable?
    ENV.j1 # Install can fail on multi-core machines unless serialized
    system "make", "osx-install"
  end

  def caveats; <<-EOS.undent
    See also https://github.com/emacs-jp/migemo to use cmigemo with Emacs.
    You will have to save as migemo.el and put it in your load-path.
    EOS
  end
end

__END__
--- a/src/wordbuf.c	2011-08-15 02:57:05.000000000 +0900
+++ b/src/wordbuf.c	2011-08-15 02:57:17.000000000 +0900
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include "wordbuf.h"

 #define WORDLEN_DEF 64
