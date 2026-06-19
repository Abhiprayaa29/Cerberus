import { configureMigrationCategoryDefaults } from "@oh-my-open-pentest/utils/migration/agent-category"

import { DEFAULT_CATEGORIES } from "../../tools/delegate-task/constants"

configureMigrationCategoryDefaults(DEFAULT_CATEGORIES)

export * from "@oh-my-open-pentest/utils/migration/agent-category"
