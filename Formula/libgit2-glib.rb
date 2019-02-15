class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.27/libgit2-glib-0.27.7.tar.xz"
  sha256 "1131df6d45e405756ef2d9b7613354d542ce99883f6a89582d6236d01bd2efc2"
  revision 1
  head "https://github.com/GNOME/libgit2-glib.git"

  bottle do
    sha256 "2beb54b07d2453b4cf5477152f0777765a52620c787737c5eb8b0b16856e08a4" => :mojave
    sha256 "2368d4a2ad407e1c87e104f0a12decdf286114cf14a9c747a13b728551d106a0" => :high_sierra
    sha256 "01e57bec3146e4806b38bb8b25912eddcda8420f66919562cdc73c8f0ba73636" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  def install
    ENV.refurbish_args

    # Fix "ld: unknown option: -Bsymbolic-functions"
    # Reported 2 Apr 2018 https://bugzilla.gnome.org/show_bug.cgi?id=794889
    inreplace "libgit2-glib/meson.build",
              "libgit2_glib_link_args = [ '-Wl,-Bsymbolic-functions' ]",
              "libgit2_glib_link_args = []"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpython=false",
                      "-Dvapi=true",
                      ".."
      system "ninja"
      system "ninja", "install"
      libexec.install Dir["examples/*"]
    end
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
