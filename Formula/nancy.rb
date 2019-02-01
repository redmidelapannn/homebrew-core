class Nancy < Formula
    desc "Golang vulnerability auditor"
  bottle do
    cellar :any_skip_relocation
    sha256 "8f7183a7cbe2c08b11605d778f6e458cf351a2cc2503bed7e36c732cb5a3ab1c" => :mojave
    sha256 "c4e7e31ca65ce9367a5ebf7745d0281424829e13d8f8592e9a000f57bec9ad41" => :high_sierra
    sha256 "ea2c1ba76f559e7e78957ce5b03ddc94dc59cac1c56c71e28cfc60710ec34e48" => :sierra
  end

    homepage "https://github.com/sonatype-nexus-community/nancy"
    url "https://github.com/sonatype-nexus-community/nancy.git",
    :tag      => "0.0.1",
    :revision => "0ddc0132e8b231d26d25d4eb71d9f273e4b01e3e"

    depends_on "go"

    def install
        ENV["GO_PATH"] = buildpath
        bin_path = buildpath/"src/github.com/sonatype-nexus-community/nancy"
        bin_path.install Dir["*"]
        cd bin_path do
        system "go", "build", "-o", bin/"nancy", "."
        end
    end

    test do
        assert_match "0.0.1", shell_output("#{bin}/nancy -version")
    end
end
