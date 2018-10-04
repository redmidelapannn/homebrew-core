class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/releases/download/v0.8.0/par2cmdline-0.8.0.tar.bz2"
  sha256 "496430e185f2d82e54245a0554341a1826f06c5e673fa12a10f176c7f9b42964"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b24aad069d8175318ff2fd13ef540281296b63b297533c77fcc79e11e37ca37a" => :mojave
    sha256 "f271aff8b7a5eff6c45770762d45d4f6fdb989e6f946b56c7b19ff61fcbf6995" => :high_sierra
    sha256 "2c3e67c64c02ed73493bf3630c83db2f2e086a34616aa24de55e39157ea3e4ad" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Protect a file with par2.
    test_file = testpath/"some-file"
    File.write(test_file, "file contents")
    system "#{bin}/par2", "create", test_file

    # "Corrupt" the file by overwriting, then ask par2 to repair it.
    File.write(test_file, "corrupted contents")
    repair_command_output = shell_output("#{bin}/par2 repair #{test_file}")

    # Verify that par2 claimed to repair the file.
    assert_match "1 file(s) exist but are damaged.", repair_command_output
    assert_match "Repair complete.", repair_command_output

    # Verify that par2 actually repaired the file.
    assert File.read(test_file) == "file contents"
  end
end
