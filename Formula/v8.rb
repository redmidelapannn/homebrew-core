# Track Chrome stable.
# https://omahaproxy.appspot.com/
class V8 < Formula
  desc "Google's JavaScript engine"
  homepage "https://github.com/v8/v8/wiki"
  url "https://chromium.googlesource.com/v8/v8.git",
    :revision => "512109444cb393dfa6ce32a36f37efde8c4fc5b9",
    :tag => "6.6.346.26"

  bottle do
    cellar :any
    sha256 "37f087a2129300cf87cb442cb91e31193ca96f5a447627b0ba4894c052e06338" => :high_sierra
    sha256 "d8c7b7c0afa25c0d74a0b778650c8020dda9e33741247e9c3ab48562a9b9901d" => :sierra
    sha256 "746134a8e065c568c08487e967d0427d97a88589405e1be2622f3eff6e656748" => :el_capitan
  end

  # https://bugs.chromium.org/p/chromium/issues/detail?id=620127
  depends_on :macos => :el_capitan

  # depot_tools/GN require Python 2.7+
  depends_on "python@2" => :build

  needs :cxx11

  resource "depot_tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
  end

  resource "chromium-buildtools" do
    url "https://chromium.googlesource.com/chromium/buildtools.git",
      :revision => "2888931260f2a32bc583f005bd807a561b2fa6af"
  end

  resource "chromium-deps-icu" do
    url "https://chromium.googlesource.com/chromium/deps/icu.git",
      :revision => "d888fd2a1be890f4d35e43f68d6d79f42519a357"
  end

  resource "chromium-src-base-trace_event-common" do
    url "https://chromium.googlesource.com/chromium/src/base/trace_event/common.git",
      :revision => "0e9a47d74970bee1bbfc063c47215406f8918699"
  end

  resource "chromium-src-build" do
    url "https://chromium.googlesource.com/chromium/src/build.git",
      :revision => "b1d6c28b4a64128ad856d9da458afda2861fddab"
  end

  resource "chromium-src-third_party-instrumented_libraries" do
    url "https://chromium.googlesource.com/chromium/src/third_party/instrumented_libraries.git",
      :revision => "b745ddca2c63719167c0f2008ae19e667c5e9952"
  end

  resource "chromium-src-third_party-jinja2" do
    url "https://chromium.googlesource.com/chromium/src/third_party/jinja2.git",
      :revision => "d34383206fa42d52faa10bb9931d6d538f3a57e0"
  end

  resource "chromium-src-third_party-markupsafe" do
    url "https://chromium.googlesource.com/chromium/src/third_party/markupsafe.git",
      :revision => "8f45f5cfa0009d2a70589bcda0349b8cb2b72783"
  end

  resource "chromium-src-tools-clang" do
    url "https://chromium.googlesource.com/chromium/src/tools/clang.git",
      :revision => "b3d3f5920b161f95f1a8ffe08b75c695e0edf350"
  end

  resource "chromium-src-tools-luci--go" do
    url "https://chromium.googlesource.com/chromium/src/tools/luci-go.git",
      :revision => "ff0709d4283b1f233dcf0c9fec1672c6ecaed2f1"
  end

  resource "external-github.com-google-googletest" do
    url "https://chromium.googlesource.com/external/github.com/google/googletest.git",
      :revision => "6f8a66431cb592dad629028a50b3dd418a408c87"
  end

  resource "external-github.com-tc39-test262" do
    url "https://chromium.googlesource.com/external/github.com/tc39/test262.git",
      :revision => "b59d956b3c268abd0875aeb87d6688f4c7aafc9b"
  end

  resource "external-github.com-test262--utils-test262--harness--py" do
    url "https://chromium.googlesource.com/external/github.com/test262-utils/test262-harness-py.git",
      :revision => "0f2acdd882c84cff43b9d60df7574a1901e2cdcd"
  end

  resource "external-github.com-webassembly-spec" do
    url "https://chromium.googlesource.com/external/github.com/WebAssembly/spec.git",
      :revision => "4653fc002a510b4f207af07f2c7c61b13dba78d9"
  end

  resource "external-googlemock" do
    url "https://chromium.googlesource.com/external/googlemock.git",
      :revision => "0421b6f358139f02e102c9c332ce19a33faf75be"
  end

  resource "external-gyp" do
    url "https://chromium.googlesource.com/external/gyp.git",
      :revision => "d61a9397e668fa9843c4aa7da9e79460fe590bfb"
  end

  resource "external-llvm.org-libunwind" do
    url "https://chromium.googlesource.com/external/llvm.org/libunwind.git",
      :revision => "86ab23972978242b6f9e27cebc239f3e8428b1af"
  end

  resource "infra-luci-client--py" do
    url "https://chromium.googlesource.com/infra/luci/client-py.git",
      :revision => "88229872dd17e71658fe96763feaa77915d8cbd6"
  end

  resource "llvm--project-cfe-tools-clang--format" do
    url "https://chromium.googlesource.com/chromium/llvm-project/cfe/tools/clang-format.git",
      :revision => "0653eee0c81ea04715c635dd0885e8096ff6ba6d"
  end

  resource "llvm--project-libcxx" do
    url "https://chromium.googlesource.com/chromium/llvm-project/libcxx.git",
      :revision => "27c341db41bc9df5c6f19cde65f002d6f1c2eb3c"
  end

  resource "llvm--project-libcxxabi" do
    url "https://chromium.googlesource.com/chromium/llvm-project/libcxxabi.git",
      :revision => "e1601db2504857d44db88a5d4e2ca50b32bbb7d9"
  end

  resource "v8-deps-third_party-benchmarks" do
    url "https://chromium.googlesource.com/v8/deps/third_party/benchmarks.git",
      :revision => "05d7188267b4560491ff9155c5ee13e207ecd65f"
  end

  resource "v8-deps-third_party-mozilla--tests" do
    url "https://chromium.googlesource.com/v8/deps/third_party/mozilla-tests.git",
      :revision => "f6c578a10ea707b1a8ab0b88943fe5115ce2b9be"
  end

  def install
    output_path = "out.gn/x64.release"

    # Trick gclient to reuse our v8 checkouts
    base = "gclient-cache/chromium.googlesource.com"
    (buildpath/"#{base}-v8-v8").install Dir["*"]

    (resources - [resource("depot_tools")]).each do |r|
      (buildpath/"#{base}-#{r.name}").install r
    end

    # Install depot_tools in PATH
    (buildpath/"depot_tools").install resource("depot_tools")
    ENV.prepend_path "PATH", buildpath/"depot_tools"

    # Prevent from updating depot_tools on every call
    # see https://www.chromium.org/developers/how-tos/depottools#TOC-Disabling-auto-update
    ENV["DEPOT_TOOLS_UPDATE"] = "0"

    # Initialize and sync gclient
    system "gclient", "root"
    system "gclient", "config", "--spec", <<~EOS
      solutions = [
        {
          "url": "https://chromium.googlesource.com/v8/v8.git",
          "managed": False,
          "name": "v8",
          "deps_file": "DEPS",
          "custom_deps": {},
        },
      ]
      target_os = [ "mac" ]
      target_os_only = True
    EOS

    system "gclient", "sync",
      "--cache-dir=#{buildpath}/gclient-cache",
      "-j", ENV.make_jobs,
      "-r", version,
      "--no-history",
      "-vvv"

    # Enter the v8 checkout
    cd "v8" do
      gn_args = {
        :is_debug => false,
        :is_component_build => true,
        :v8_use_external_startup_data => false,
        :v8_enable_i18n_support => true,
      }

      # Transform to args string
      gn_args_string = gn_args.map { |k, v| "#{k}=#{v}" }.join(" ")

      # Build with gn + ninja
      system "gn",
        "gen",
        "--args=#{gn_args_string}",
        output_path

      system "ninja",
        "-j", ENV.make_jobs,
        "-C", output_path,
        "-v",
        "d8"

      # Install all the things
      include.install Dir["include/*"]
      cd output_path do
        lib.install Dir["lib*.dylib"]

        # Install d8 and icudtl.dat in libexec and symlink
        # because they need to be in the same directory.
        libexec.install Dir["d8", "icudt*.dat"]
        mkdir_p bin
        (bin/"d8").atomic_write <<~EOS
          #!/bin/bash
          exec "#{libexec}/d8" --icu-data-file="#{libexec}/icudtl.dat" "$@"
        EOS
      end
    end
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/d8 -e 'print(\"Hello World!\");'").chomp
    assert_match %r{12/\d{2}/2012}, shell_output("#{bin}/d8 -e 'print(new Intl.DateTimeFormat(\"en-US\").format(new Date(Date.UTC(2012, 11, 20, 3, 0, 0))));'").chomp
  end
end
