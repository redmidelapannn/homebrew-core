class Clips < Formula
  desc "Tool for Building Expert Systems"
  homepage "http://www.clipsrules.net"
  url "https://downloads.sourceforge.net/project/clipsrules/CLIPS/6.30/clips_core_source_630.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fclipsrules%2Ffiles%2FCLIPS%2F6.30%2F&ts=1499963701"
  version "6.30"
  sha256 "01555b257efae281199b82621ad5cc1106a395acc095b9ba66f40fe50fe3ef1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2720448100c0f75baaef9b5a18fdaa27bd5c85981e034b2d5cd84303dadd2801" => :sierra
    sha256 "8c55565855e1f831029f66f5435934b72119b78b96dc2510c97bac995e794270" => :el_capitan
    sha256 "60050839ba172b0ff4c2f8144d52d8037509a9625c8e51df20deb9e9df36b85e" => :yosemite
  end

  def install
    inreplace "makefiles/makefile.gcc", "gcc", "clang"

    system "make", "-f", "../makefiles/makefile.gcc", "-C", "core"
    bin.install "core/clips"
  end

  test do
    IO.popen("#{bin}/clips", "w") do |pipe|
      pipe.puts "(exit)\n"
      pipe.close_write
    end
  end
end
