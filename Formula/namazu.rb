class Namazu < Formula
  desc "Full-text search engine"
  homepage "http://www.namazu.org/"
  url "http://www.namazu.org/stable/namazu-2.0.21.tar.gz"
  sha256 "5c18afb679db07084a05aca8dffcfb5329173d99db8d07ff6d90b57c333c71f7"

  bottle do
    rebuild 2
    sha256 "3606add273bdd59cf2bf943f7ba4269eaf2a9b440218957854b64183f63cf9b6" => :high_sierra
    sha256 "3f1c20a3cb5f5031a26b4d3166326bd08d6396fef838e5218c716773f6b42ec3" => :sierra
    sha256 "000648d065fb09c18caa483c8354d390b93fae553a85c80686b932a560b3ef9e" => :el_capitan
  end

  option "with-japanese", "Support for japanese character encodings."

  depends_on "kakasi" if build.with? "japanese"

  patch :DATA

  resource "text-kakasi" do
    url "https://cpan.metacpan.org/authors/id/D/DA/DANKOGAI/Text-Kakasi-2.04.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/D/DA/DANKOGAI/Text-Kakasi-2.04.tar.gz"
    sha256 "844c01e78ba4bfb89c0702995a86f488de7c29b40a75e7af0e4f39d55624dba0"
  end

  def install
    if build.with? "japanese"
      resource("text-kakasi").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    cd "File-MMagic" do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--with-pmdir=#{libexec}/lib/perl5"]
    system "./configure", *args
    system "make", "install"
  end

  test do
    data_file = testpath/"data.txt"
    data_file.write "This is a Namazu test case for Homebrew."
    mkpath "idx"

    system bin/"mknmz", "-O", "idx", data_file
    search_result = shell_output("#{bin}/namazu -a Homebrew idx")
    assert_match /#{data_file}/, search_result
  end
end

__END__
From 9029688dad93777335c530c9574d1fb208c79728 Mon Sep 17 00:00:00 2001
From: NOKUBI Takatsugu <knok@daionet.gr.jp>
Date: Fri, 26 Aug 2011 06:20:22 +0000
Subject: [PATCH] Changed to use memmove instead of strcpy with overwrapped
 buffers.

---
 nmz/search.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/nmz/search.c b/nmz/search.c
index b8d015d..7c2e76a 100644
--- a/nmz/search.c
+++ b/nmz/search.c
@@ -569,7 +569,7 @@ do_regex_preprocessing(char *expr)
 {
     if (*expr == '*' && expr[strlen(expr) - 1] != '*') {
         /* If suffix match such as '*bar', enforce it into regex */
-        strcpy(expr, expr + 1);
+        memmove(expr, expr + 1, strlen(expr));
         escape_meta_characters(expr, BUFSIZE * 2);
         strncat(expr, "$", BUFSIZE * 2 - strlen(expr) - 1);
         expr[BUFSIZE * 2 - 1] = '\0';
@@ -581,7 +581,7 @@ do_regex_preprocessing(char *expr)
         expr[BUFSIZE * 2 - 1] = '\0';
     } else if (*expr == '*' && expr[strlen(expr) - 1] == '*') {
         /* If internal match such as '*foo*', enforce it into regex */
-        strcpy(expr, expr + 1);
+        memmove(expr, expr + 1, strlen(expr));
         expr[strlen(expr) - 1] = '\0';
         escape_meta_characters(expr, BUFSIZE * 2);
     } else if (*expr == '/' && expr[strlen(expr) - 1] == '/') {
@@ -589,7 +589,7 @@ do_regex_preprocessing(char *expr)
             nmz_debug_printf("do REGEX search\n");
             /* Genuine regex */
             /* Remove the both of '/' chars at begging and end of string */
-            strcpy(expr, expr + 1);
+            memmove(expr, expr + 1, strlen(expr));
             expr[strlen(expr) - 1]= '\0';
         } else {
             nmz_debug_printf("disabled REGEX search\n");
@@ -602,7 +602,7 @@ do_regex_preprocessing(char *expr)
             || (*expr == '{' && expr[strlen(expr) - 1] == '}')) 
         {
             /* Delimiters of field search */
-            strcpy(expr, expr + 1); 
+            memmove(expr, expr + 1, strlen(expr)); 
             expr[strlen(expr) - 1] = '\0';
         }
         escape_meta_characters(expr, BUFSIZE * 2);
@@ -692,7 +692,7 @@ static void
 delete_beginning_backslash(char *str)
 {
     if (*str == '\\') {
-        strcpy(str, str + 1);
+        memmove(str, str + 1, strlen(str));
     }
 }
 
@@ -932,7 +932,7 @@ void remove_quotes(char *str)
     if ((strlen(str) >= 3 && (*str == '"' && str[strlen(str) - 1] == '"'))
         || (*str == '{' && str[strlen(str) - 1] == '}')) 
     {
-        strcpy(str, str + 1); 
+        memmove(str , str + 1, strlen(str)); 
         str[strlen(str) - 1]= '\0';
     } 
 }
