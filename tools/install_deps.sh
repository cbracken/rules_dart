#!/bin/sh

BAZEL_VERSION=4.0.0

linux_install() {
  echo "============================================================"
  echo "Installing Bazel $BAZEL_VERSION on Linux"
  echo "============================================================"

  sudo apt -y update
  sudo apt -y install apt-transport-https curl gnupg
  curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg
  sudo mv bazel.gpg /etc/apt/trusted.gpg.d/
  echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
  sudo apt update
  sudo apt -y install bazel-$BAZEL_VERSION
  exit 0
}

macos_install() {
  echo "============================================================"
  echo "Installing Bazel $BAZEL_VERSION on macOS"
  echo "============================================================"

  curl -fLO "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh"
  chmod +x "bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh"
  sudo ./bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh
  exit 0
}

# Main entry point.
case "`uname -s`" in
  Linux*) linux_install;;
  Darwin*) macos_install;;
esac

echo "ERROR: unknown operating system"
exit 1
