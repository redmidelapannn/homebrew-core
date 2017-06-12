class GoAT17 < Formula
  desc "Go programming environment (1.7)"
  homepage "https://golang.org"
  url "https://storage.googleapis.com/golang/go1.7.6.src.tar.gz"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/golang/go1.7.6.src.tar.gz/sha512/b01846bfb17bf91a9c493c4d6c43bbe7e17270b9e8a229a2be4032b78ef9395f5512917ea9faab74a120c755bbd53bbd816b033caadcbb7679e91702b37f8c7f/go1.7.6.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.7.6.src.tar.gz"
  version "1.7.6"
  sha256 "1a67a4e688673fdff7ba41e73482b0e59ac5bd0f7acf703bc6d50cc775c5baba"

  bottle do
    rebuild 1
    sha256 "0e250d861c6bd7256874b3d2a293cd1b5969f746376dadadd2106f8c4b883ec1" => :sierra
    sha256 "4fad62dd005353cb4cb7975bd0d172228cb859141bdd336521dff37f1d1da823" => :el_capitan
    sha256 "211a585f4f732acf52b0c48340969328533e0cc74869e949e8e7f7295f303162" => :yosemite
  end

  keg_only :versioned_formula

  option "without-cgo", "Build without cgo (also disables race detector)"
  option "without-godoc", "godoc will not be installed for you"
  option "without-race", "Build without race detector"

  depends_on :macos => :mountain_lion

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.7"
  end

  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.4-bootstrap-20161024.tar.gz"
    sha256 "398c70d9d10541ba9352974cc585c43220b6d8dbcd804ba2c9bd2fbf35fab286"
  end

  def install
    # GOROOT_FINAL must be overidden later on real Go install
    ENV["GOROOT_FINAL"] = buildpath/"gobootstrap"

    # build the gobootstrap toolchain Go >=1.4
    (buildpath/"gobootstrap").install resource("gobootstrap")
    cd "#{buildpath}/gobootstrap/src" do
      system "./make.bash", "--no-clean"
    end

    # This should happen after we build the test Go, just in case
    # the bootstrap toolchain is aware of this variable too.
    ENV["GOROOT_BOOTSTRAP"] = ENV["GOROOT_FINAL"]
    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      ENV["CGO_ENABLED"]  = "0" if build.without?("cgo")
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/go*"]

    # Race detector only supported on amd64 platforms.
    # https://golang.org/doc/articles/race_detector.html
    if build.with?("cgo") && build.with?("race") && MacOS.prefer_64_bit?
      system "#{bin}/go", "install", "-race", "std"
    end

    if build.with?("godoc")
      ENV.prepend_path "PATH", bin
      ENV["GOPATH"] = buildpath
      (buildpath/"src/golang.org/x/tools").install resource("gotools")

      if build.with? "godoc"
        cd "src/golang.org/x/tools/cmd/godoc/" do
          system "go", "build"
          (libexec/"bin").install "godoc"
        end
        bin.install_symlink libexec/"bin/godoc"
      end
    end
  end

  def caveats; <<-EOS.undent
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/"hello.go").write <<-EOS.undent
    package main
    import "fmt"
    func main() {
        fmt.Println("Hello World")
    }
    EOS

    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system "#{bin}/go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    if build.with? "godoc"
      assert File.exist?(libexec/"bin/godoc")
      assert File.executable?(libexec/"bin/godoc")
    end

    if build.with? "cgo"
      ENV["GOOS"] = "freebsd"
      system bin/"go", "build", "hello.go"
    end
  end
end
