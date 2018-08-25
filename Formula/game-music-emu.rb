class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.2.tar.xz"
  sha256 "5046cb471d422dbe948b5f5dd4e5552aaef52a0899c4b2688e5a68a556af7342"
  head "https://bitbucket.org/mpyne/game-music-emu.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a0b8014a11cbab1dce45c92e2820d47eae82f1eb2826265df8a908e98df9d363" => :high_sierra
    sha256 "390596d9489a497101a22cb89b9433ac74255717f69e33b1640162fdaab914aa" => :sierra
    sha256 "0c1f5f69005c7d013af3199dc637c139045fb94a9bc207344d67b591ee67e75d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "sdl" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    if build.with? "sdl"
      cd "player" do
        system "make"

        # gme_player will have linked against the version of libgme in the buildpath,
        # and we haven't yet fixed its dylib ID. Do that manually here because this
        # won't be automatically fixable later.
        dylib_id = MachO::MachOFile.new("#{buildpath}/gme/libgme.0.dylib").dylib_id
        MachO::Tools.change_install_name("gme_player", dylib_id, "#{lib}/libgme.0.dylib")

        bin.install "gme_player"
      end
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gme/gme.h>
      int main(void)
      {
        Music_Emu* emu;
        gme_err_t error;

        error = gme_open_data((void*)0, 0, &emu, 44100);

        if (error == gme_wrong_file_type) {
          return 0;
        } else {
          return -1;
        }
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lgme", "-o", "test", *ENV.cflags.to_s.split
    system "./test"
  end
end
