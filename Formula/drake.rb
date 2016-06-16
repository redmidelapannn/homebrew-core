class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage "https://github.com/Factual/drake"
  url "https://raw.githubusercontent.com/Factual/drake/1.0.3/bin/drake-pkg"
  version "1.0.3"
  sha256 "adeb0bb14dbe39789273c5c766da9a019870f2a491ba1f0c8c328bd9a95711cc"
  head "https://github.com/Factual/drake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62b2c8a3f7ab889a438a9dd4836c8941085132f4d869794ca61acc965ad33099" => :el_capitan
    sha256 "74e84ccf1fb24d58e4aff4b6cc6a80685e8563dd372ef3c00639e1fbc1b4ddff" => :yosemite
    sha256 "313746083ca9390113d4d643a8334a38f6d7a564518500a9dd39a1d08678444d" => :mavericks
  end

  resource "jar" do
    url "https://github.com/Factual/drake/releases/download/1.0.3/drake.jar"
    sha256 "c9c5b109a900b6f30257425feee7a4e05ef11cc34cf227b04207a2f8645316af"
  end

  def install
    jar = "drake-#{version}-standalone.jar"
    inreplace "drake-pkg", /DRAKE_JAR/, libexec/jar
    bin.install "drake-pkg" => "drake"
    resource("jar").stage do
      libexec.install "drake.jar" => jar
    end
  end

  test do
    # count lines test
    (testpath/"Drakefile").write <<-EOS.undent
      find_lines <- [shell]
        echo 'drake' > $OUTPUT

      count_drakes_lines <- find_lines
        cat $INPUT | wc -l > $OUTPUT
    EOS

    # force run (no user prompt) the full workflow
    system bin/"drake", "--auto", "--workflow=#{testpath}/Drakefile", "+..."
  end
end
