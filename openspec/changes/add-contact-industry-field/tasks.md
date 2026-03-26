## 1. 数据库模式

- [ ] 1.1 在 `supabase/schemas/01_tables.sql` 中为 `contacts` 表添加 `industry text` 字段
- [ ] 1.2 在 `supabase/schemas/03_views.sql` 中为 `contacts_summary` 视图添加 `industry` 字段
- [ ] 1.3 使用 `npx supabase db diff --local -f add_contact_industry` 生成并应用数据库迁移

## 2. 配置

- [ ] 2.1 在 `ConfigurationContext.tsx` 的 `ConfigurationContextValue` 中添加 `contactIndustries: LabeledValue[]`
- [ ] 2.2 在 `defaultConfiguration.ts` 中添加 `defaultContactIndustries`（复用 `companySectors` 的值）
- [ ] 2.3 在 `<CRM>` 组件中接入 `contactIndustries` 属性

## 3. 类型定义

- [ ] 3.1 在 `types.ts` 的 `Contact` 类型中添加 `industry?: string`

## 4. 联系人表单

- [ ] 4.1 在 `ContactInputs.tsx` 的 `ContactPositionInputs` 中添加行业 `SelectInput`（与 title 和 company 并列）

## 5. 联系人列表筛选

- [ ] 5.1 在 `ContactListFilter.tsx` 中添加"行业" `FilterCategory` 及切换按钮

## 6. CSV 导入/导出

- [ ] 6.1 在示例 CSV 文件 `contacts_export.csv` 中添加 `industry` 列
- [ ] 6.2 在 `useContactImport.tsx` 中为 `ContactImportSchema` 和导入逻辑添加 `industry`
- [ ] 6.3 在 CSV 导出逻辑中添加 `industry`

## 7. FakeRest 数据生成器

- [ ] 7.1 在 `providers/fakerest/dataGenerator/contacts.ts` 中添加 `industry` 字段生成
- [ ] 7.2 如适用，在 FakeRest 的 contacts_summary 视图模拟中添加 `industry`

## 8. 联系人合并与 vCard 导出

- [ ] 8.1 确保联系人合并逻辑处理 `industry` 字段
- [ ] 8.2 在 vCard 导出中包含 `industry`（映射到 NOTE 或 ORG 子字段）

## 9. 验证

- [ ] 9.1 运行 `make typecheck` 并修复所有类型错误
- [ ] 9.2 运行 `make test` 并修复所有测试失败
- [ ] 9.3 验证联系人表单、列表筛选、CSV 导入/导出和 FakeRest 演示模式中新字段均正常工作
