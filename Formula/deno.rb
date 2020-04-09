class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v0.40.0/deno_src.tar.gz"
  sha256 "d2ed1ac06fd2901145374eb39adf4519e4119f86d82851b5947e58937116c2b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9cf439676526c84702fe2fed21b07aabc09444dc0a263a7be1cabac6f194690e" => :catalina
    sha256 "d8fad39cef0eccd77b9ac84f44bad5e89194d3bd44e409618f7e781fb2fe9a95" => :mojave
    sha256 "4a0730b78654354c979fdbcbc02a89c31c99de71b46b06418b1309d310bd6609" => :high_sierra
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build

  depends_on :xcode => ["10.0", :build] # required by v8 7.9+

  uses_from_macos "xz"

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "fd3d768bcfd44a8d9639fe278581bd9851d0ce3a"
  end

  def install
    # Build gn from source (used as a build tool here)
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end

    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # overwrite Chromium minimum sdk version of 10.15
    ENV["FORCE_MAC_SDK_MIN"] = "10.13"
    # build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    cd "cli" do
      system "cargo", "install", "-vv", "--locked", "--root", prefix, "--path", "."
    end

    # Install bash and zsh completion
    output = Utils.popen_read("#{bin}/deno completions bash")
    (bash_completion/"deno").write output
    output = Utils.popen_read("#{bin}/deno completions zsh")
    (zsh_completion/"_deno").write output
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
