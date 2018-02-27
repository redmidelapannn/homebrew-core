class Fortune < Formula
  desc "Infamous electronic fortune-cookie generator"
  homepage "https://www.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html"
  url "https://www.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/fortune-mod/fortune-mod-9708.tar.gz/81a87a44f9d94b0809dfc2b7b140a379/fortune-mod-9708.tar.gz"
  sha256 "1a98a6fd42ef23c8aec9e4a368afb40b6b0ddfb67b5b383ad82a7b78d8e0602a"

  bottle do
    rebuild 3
    sha256 "bfe3328d20a4dd13bb59dcfdd84f0d0e3e5898a94da45a07c2ebdb8491763136" => :high_sierra
    sha256 "9d9ed3a5b93d4ecc1b90a0ad5f8ff1e91d1410db3f02a5117256ff37e449c173" => :sierra
    sha256 "30f5e288f99b5189247ebc2b868eff59a6bcf7d1d9a543c52b1d0cb24ba539e4" => :el_capitan
  end

  option "without-offensive", "Don't install potentially offensive fortune files"

  deprecated_option "no-offensive" => "without-offensive"

  def install
    ENV.deparallelize

    inreplace "Makefile" do |s|
      # Use our selected compiler
      s.change_make_var! "CC", ENV.cc

      # Change these first two folders to the correct location in /usr/local...
      s.change_make_var! "FORTDIR", "/usr/local/bin"
      s.gsub! "/usr/local/man", "/usr/local/share/man"
      # Now change all /usr/local at once to the prefix
      s.gsub! "/usr/local", prefix

      # macOS only supports POSIX regexes
      s.change_make_var! "REGEXDEFS", "-DHAVE_REGEX_H -DPOSIX_REGEX"
      # Don't install offensive fortunes
      s.change_make_var! "OFFENSIVE", "0" if build.without? "offensive"
    end

    system "make", "install"
  end

  test do
    system "#{bin}/fortune"
  end
end
