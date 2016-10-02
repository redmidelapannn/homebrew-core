class Bullshtml < Formula
  desc "Html Reporter for BullseyeCoverage tool."
  homepage "https://github.com/RafalSkorka/bullshtml"
  url "https://github.com/RafalSkorka/bullshtml.git",
      :tag => "1.0.6",
      :revision => "43efec2ff5ea7db9622c679616908aeacf46e7b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac2c8ec76425f27b131aded240fd509d9d81704a2753a38497979fdf04c5b08b" => :sierra
    sha256 "1bb77aac08a34b4dd356337aa0d7793a2eed4c6b59e9121a03769369043c99d8" => :el_capitan
    sha256 "67c7939f487037e259a8bee6841a39bf2c9c16cd593ff3194979d13caa37817e" => :yosemite
  end

  depends_on "ant" => :build
  depends_on :java => "1.6+"

  def install
    ENV.java_cache
    system "ant", "make_onejar", "-Ddebuglevel=none"

    libexec.install "target/bullshtml.jar"
    (bin/"bullshtml").write <<-EOS.undent
      #!/bin/bash
      exec java -jar #{libexec}/bullshtml.jar "$@"
    EOS
  end

  test do
    system bin/"bullshtml", "-h"
  end
end
