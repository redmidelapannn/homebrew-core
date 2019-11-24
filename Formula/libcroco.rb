class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.13.tar.xz"
  sha256 "767ec234ae7aa684695b3a735548224888132e063f92db585759b422570621d4"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "b51db6f71a923840dae8f72f0f607839fc4ba00810ceefb725bbccba2df16c5e" => :catalina
    sha256 "b17c4c27c249b8fd6ce500de80146f6b2b5aa1fe94ac8c4277a210aeeb4a9ae7" => :mojave
    sha256 "2d08e71aea151d76c2ce5665318216df9d572604291c6c16d848a73a774ece28" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  uses_from_macos "libxml2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system "make", "install"
  end

  test do
    (testpath/"test.css").write ".brew-pr { color: green }"
    assert_equal ".brew-pr {\n  color : green\n}",
      shell_output("#{bin}/csslint-0.6 test.css").chomp
  end
end
