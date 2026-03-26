## 为什么要做

联系人（Contact）目前缺少"所属行业"字段，无法按行业维度对客户进行分类。销售团队需要按行业筛选和分析联系人，以便确定优先级、定制沟通策略并生成行业相关报告。添加此字段可填补联系人数据模型的空白，提升销售管道管理能力。

## 变更内容

- 在 `contacts` 表和 `contacts_summary` 视图中添加 `industry` 文本字段
- 在 CRM 配置上下文中添加 `contactIndustries` 配置项（类型为 `LabeledValue[]`），沿用 `companySectors` 的模式
- 在联系人创建/编辑表单的"职位"区域添加行业下拉选择器（`SelectInput`），与 title 和 company 并列
- 在联系人列表筛选器中添加"行业"筛选分类
- 更新 FakeRest 数据生成器，生成随机行业值
- 更新 CSV 导入/导出，包含 `industry` 字段
- 更新联系人合并逻辑，处理 `industry` 字段
- 更新 vCard 导出（将行业映射到相关的 vCard 字段或 ORG 子字段）

## 能力范围

### 新增能力
- `contact-industry`：为联系人添加行业字段，包含配置驱动的选项列表、列表筛选、表单输入、CSV 导入/导出及 FakeRest 数据生成

### 修改的能力
<!-- 无需修改现有能力 -->

## 影响范围

- **数据库**：`contacts` 表新增字段、更新 `contacts_summary` 视图、新增迁移文件
- **前端**：更新 ContactInputs、ContactListFilter、联系人类型定义、CSV 导入/导出、FakeRest 数据生成器、联系人合并逻辑
- **配置**：`<CRM>` 组件新增 `contactIndustries` 属性、`defaultConfiguration.ts` 新增默认值、更新 `ConfigurationContext`
- **API**：无需修改 REST API（Supabase 会自动暴露新字段）
