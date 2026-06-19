import { createProductIdentity } from "@omop/utils"

const PRODUCT_IDENTITY = createProductIdentity({
  pluginName: "oh-my-open-pentest",
  legacyPluginName: "oh-my-open-pentest",
  publishedPackageName: "oh-my-open-pentest",
  acceptedPackageNames: ["oh-my-open-pentest", "oh-my-open-pentest"],
  configBasename: "oh-my-open-pentest",
  legacyConfigBasename: "oh-my-open-pentest",
  logFileName: "oh-my-open-pentest.log",
  cacheDirName: "oh-my-open-pentest",
})

export const PLUGIN_NAME = PRODUCT_IDENTITY.pluginName
export const LEGACY_PLUGIN_NAME = PRODUCT_IDENTITY.legacyPluginName
export const PUBLISHED_PACKAGE_NAME = PRODUCT_IDENTITY.publishedPackageName
export const ACCEPTED_PACKAGE_NAMES = PRODUCT_IDENTITY.acceptedPackageNames
export const CONFIG_BASENAME = PRODUCT_IDENTITY.configBasename
export const LEGACY_CONFIG_BASENAME = PRODUCT_IDENTITY.legacyConfigBasename
export const LOG_FILENAME = PRODUCT_IDENTITY.logFileName
export const CACHE_DIR_NAME = PRODUCT_IDENTITY.cacheDirName
