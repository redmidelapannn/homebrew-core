class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"

  stable do
    url "https://fishshell.com/files/2.3.1/fish-2.3.1.tar.gz"
    mirror "https://github.com/fish-shell/fish-shell/releases/download/2.3.1/fish-2.3.1.tar.gz"
    sha256 "328acad35d131c94118c1e187ff3689300ba757c4469c8cc1eaa994789b98664"

    # Skip extra dirs creation during install phase patch for current stable. To be removed on the next fish release.
    # As discussed in https://github.com/Homebrew/homebrew-core/pull/2813
    # Use part of https://github.com/fish-shell/fish-shell/commit/9abbc5f upstream commit and patch the makefile.
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 "8bbc2fc7df486bbaa35eacf735de14e7f50fb6c5d4d7f450fc7e0e13d0c9267c" => :sierra
    sha256 "a32bd6f7a95a7ef759ef9d10a9e516698dee109a2fda58881fe4f2024fd1fc07" => :el_capitan
    sha256 "768f070218901808339e3ccc0cf78cc86e27257e2d2bdb1b542f59b178d0d1dd" => :yosemite
  end

  devel do
    url "https://github.com/fish-shell/fish-shell/releases/download/2.4b1/fish-2.4b1.tar.gz"
    sha256 "36139e09064f7904d8b7de4603789c41c1a9bf425280494468948de61572cbbd"

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"

  def install
    system "autoconf" if build.head? || build.devel?

    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      --prefix=#{prefix}
      --with-extra-functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      --with-extra-completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      --with-extra-confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
      SED=/usr/bin/sed
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells.

    Then run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end

__END__
As discussed in https://github.com/Homebrew/homebrew-core/pull/2813
Grab part of https://github.com/fish-shell/fish-shell/commit/9abbc5f upstream commit and patch the makefile.
--- a/Makefile.in
+++ b/Makefile.in@@ -664,5 +664,5 @@ install-force: all install-translations
@@ -664,5 +664,5 @@ install-force: all install-translations
	$(INSTALL) -m 755 -d $(DESTDIR)$(datadir)/fish/completions
-	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_completionsdir)
-	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_functionsdir)
-	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_confdir)
+	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_completionsdir); true
+	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_functionsdir); true
+	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_confdir); true
	$(INSTALL) -m 755 -d $(DESTDIR)$(datadir)/fish/functions
