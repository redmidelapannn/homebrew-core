class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v0.40.0/deno_src.tar.gz"
  sha256 "d2ed1ac06fd2901145374eb39adf4519e4119f86d82851b5947e58937116c2b0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8dc582d6976651754e513b4416b6b085ec9aeb3993badb8069604058c79ce18b" => :catalina
    sha256 "850c34120d4104f6517dae6082c74587d66098a2701e7a84d8532bd449abd1af" => :mojave
    sha256 "d8fec7ce8ce23e09a1f30529f722c83bdc2f5f97f84a4a30851c6d7512f6bf0d" => :high_sierra
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on :macos # Due to Python 2 (see https://github.com/denoland/deno/issues/2893)

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
