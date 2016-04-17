class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "http://www.ifdo.ca/~seymour/runabc/top.html"
  url "http://www.ifdo.ca/~seymour/runabc/abcMIDI-2016.03.03.zip"
  version "2016-03-03"
  sha256 "a9070dbb49758474805252d1a3e837aef8dc1266f6415f8eccc7df118af3dc1e"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "a3e82aa8e02c00ea74c6b8e70738df5f6d08f04113cce91ef00dcabf5d3b775e" => :el_capitan
    sha256 "7d90297cd26e737ef63c94a17672e15a8d424a4bf1f9279432dba1f3da800b60" => :yosemite
    sha256 "5714311d62e7e9ab48d84dbbdf82bc7b466d606f656c87ba97c07e3a7ffc6026" => :mavericks
  end

  def install
    # configure creates a "Makefile" file. A "makefile" file already exist in
    # the tarball. On case-sensitive file-systems, the "makefile" file won't
    # be overridden and will be chosen over the "Makefile" file.
    rm "makefile"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<-EOF.undent
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordian
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOF

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
