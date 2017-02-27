class BazelAT032 < Formula
  desc "Google's own build tool"
  homepage "https://www.bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.3.2.tar.gz"
  sha256 "9692ac3318a40e8a0530f68bbfc473ae5f6a4a5c0fe08d2f88612ca4d40ba54a"
  head "https://github.com/bazelbuild/bazel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8043353ce411bfc08bb4e23085bdef940bffaaf1226d4244e559aff22030378f" => :sierra
    sha256 "211d38a158c3f941c20333ea70f70bd4aae963a5e5990b069cfc9aef8dfc0478" => :el_capitan
    sha256 "ab6159e4758e9252d94b14787cba7c2ed7450b0c4d51b9b10452d6822640076d" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite
  keg_only :versioned_formula

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    system "./compile.sh"
    system "./output/bazel", "--output_user_root", buildpath/"output_user_root",
           "build", "scripts:bash_completion"

    bin.install "scripts/packages/bazel.sh" => "bazel"
    bin.install "output/bazel" => "bazel-real"
    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<-EOS.undent
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<-EOS.undent
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin/"bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
