class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-5.2.1-RELEASE.tar.gz"
  sha256 "3488e920ad989b1c6a8d25ef241d356a9951184fefcad19e230e3263b6e80f48"

  bottle do
    sha256 "cc4149ba5d97c882124ade448cf7ba340d88bb38df2036acda67bae8a15107a1" => :catalina
    sha256 "eb5c5a8dd1c1fdd0b47bda926b1a884a2f0f7a99b482f26ff3dc3fcac022d944" => :mojave
  end

  keg_only :provided_by_macos, "Apple's CLT package contains Swift"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Depends on latest version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["11.2", :build]

  uses_from_macos "icu4c"

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.2.1-RELEASE.tar.gz"
    sha256 "f21cfa75413ab290991f28a05a975b15af9289140e2f595aa981e630496907e7"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.2.1-RELEASE.tar.gz"
    sha256 "ac18a4a55739af8afb9009f4d8d7643a78fda47a329e1b1f8c782122db88b3b1"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.2.1-RELEASE.tar.gz"
    sha256 "8812862ef27079fb41f13ac3e741a1e488bd321d79c6a57d026ca1c1e25d90c7"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.2.1-RELEASE.tar.gz"
    sha256 "73e12edffce218d1fdfd626c2000a9d9f5805a946175899600b50379e885770e"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.2.1-RELEASE.tar.gz"
    sha256 "43af8eeb9c98847bc610a2093d341b608a4120628c4aa0a410d157c4100d400e"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.2.1-RELEASE.tar.gz"
    sha256 "9dd65a18a3cff3efcb792b3df96385da1a095645d9c544a122dc3ec9ae7e7938"
  end

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    toolchain_prefix = "/Swift-#{version}.xctoolchain"
    install_prefix = "#{toolchain_prefix}/usr"

    ln_sf buildpath, workspace/"swift"
    resources.each { |r| r.stage(workspace/r.name) }

    mkdir build do
      # List of components to build
      swift_components = %w[
        compiler clang-resource-dir-symlink stdlib sdk-overlay
        tools editor-integration toolchain-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers parser-lib
      ]
      llvm_components = %w[
        llvm-cov llvm-profdata IndexStore clang
        clang-resource-headers compiler-rt clangd
      ]

      system "#{workspace}/swift/utils/build-script",
        "--release", "--assertions",
        "--no-swift-stdlib-assertions",
        "--build-subdir=#{build}",
        "--llbuild", "--swiftpm",
        "--indexstore-db", "--sourcekit-lsp",
        "--jobs=#{ENV.make_jobs}",
        "--verbose-build",
        "--",
        "--workspace=#{workspace}",
        "--install-destdir=#{prefix}",
        "--toolchain-prefix=#{toolchain_prefix}",
        "--install-prefix=#{install_prefix}",
        "--host-target=macosx-x86_64",
        "--stdlib-deployment-targets=macosx-x86_64",
        "--build-swift-dynamic-stdlib",
        "--build-swift-dynamic-sdk-overlay",
        "--build-swift-stdlib-unittest-extra",
        "--install-swift",
        "--swift-install-components=#{swift_components.join(";")}",
        "--llvm-install-components=#{llvm_components.join(";")}",
        "--install-llbuild",
        "--install-swiftpm",
        "--install-sourcekit-lsp"
    end
  end

  test do
    ENV["SDKROOT"] = MacOS::Xcode.sdk_path

    (testpath/"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\(base)^\(exponent_inner))^\(exponent_outer) == \(answer)")
    EOS
    output = shell_output("#{prefix}/Swift-#{version}.xctoolchain/usr/bin/swift test.swift")
    assert_match "(2^3)^4 == 4096\n", output
  end
end
