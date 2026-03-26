## 新增需求

### 需求：联系人具有行业字段
系统应（SHALL）在每条联系人记录上存储一个可选的 `industry` 文本字段。该值必须（MUST）是已配置的 `contactIndustries` 列表中的 slug 或 null。

#### 场景：创建联系人时未指定行业
- **当（WHEN）** 创建联系人时未指定行业
- **则（THEN）** 该联系人的 `industry` 字段应为 null

#### 场景：创建联系人时指定行业
- **当（WHEN）** 创建联系人时将 `industry` 设为 `"information-technology"`
- **则（THEN）** 该联系人记录应存储 `"information-technology"` 作为行业值

### 需求：联系人行业可通过 CRM 属性配置
系统应（SHALL）在 `<CRM>` 组件上接受 `contactIndustries` 属性（类型为 `LabeledValue[]`）。此配置应通过 `useConfigurationContext()` 获取。默认值应与 `companySectors` 默认值一致。

#### 场景：提供自定义行业列表
- **当（WHEN）** CRM 以 `contactIndustries={[{value: "tech", label: "科技"}, {value: "finance", label: "金融"}]}` 渲染时
- **则（THEN）** 联系人表单和筛选器应使用这些自定义行业选项

#### 场景：未提供自定义行业列表
- **当（WHEN）** CRM 渲染时未传入 `contactIndustries` 属性
- **则（THEN）** 系统应使用默认行业列表（与 `companySectors` 默认值一致）

### 需求：联系人表单包含行业选择器
系统应（SHALL）在联系人创建/编辑表单的"职位"区域中显示行业下拉选择器（SelectInput），与 title 和 company 并列。

#### 场景：在表单中选择行业
- **当（WHEN）** 用户编辑联系人并从行业下拉框中选择"信息技术"
- **则（THEN）** 该联系人的 `industry` 字段应保存为 `"information-technology"`

#### 场景：在表单中清除行业
- **当（WHEN）** 用户编辑联系人并清除行业选择
- **则（THEN）** 该联系人的 `industry` 字段应保存为 null

### 需求：联系人列表支持按行业筛选
系统应（SHALL）在联系人列表视图中提供"行业"筛选分类。每个已配置的行业应显示为一个切换筛选按钮。

#### 场景：按单个行业筛选
- **当（WHEN）** 用户激活"信息技术"行业筛选器
- **则（THEN）** 联系人列表应仅显示 `industry` 等于 `"information-technology"` 的联系人

#### 场景：未激活任何行业筛选
- **当（WHEN）** 未选择任何行业筛选器
- **则（THEN）** 联系人列表应显示所有联系人，不受行业值限制

### 需求：CSV 导出包含行业
系统应（SHALL）在联系人 CSV 导出中包含 `industry` 列，内容为行业 slug 值。

#### 场景：导出有行业的联系人
- **当（WHEN）** 用户导出联系人为 CSV，且某联系人的 `industry` = `"financials"`
- **则（THEN）** 导出的 CSV 行中 `industry` 列应包含 `financials`

#### 场景：导出无行业的联系人
- **当（WHEN）** 用户导出联系人为 CSV，且某联系人未设置行业
- **则（THEN）** 导出的 CSV 行中 `industry` 列应为空

### 需求：CSV 导入支持行业
系统应（SHALL）接受导入 CSV 文件中的 `industry` 列。该值必须（MUST）是有效的行业 slug 或为空。

#### 场景：导入含行业的联系人
- **当（WHEN）** 用户导入的 CSV 文件中 `industry` 列包含 `"energy"`
- **则（THEN）** 导入的联系人应将 `industry` 设为 `"energy"`

#### 场景：导入不含行业列的 CSV
- **当（WHEN）** 用户导入的 CSV 文件不包含 `industry` 列
- **则（THEN）** 导入的联系人应将 `industry` 设为 null

### 需求：FakeRest 数据生成器生成行业值
FakeRest 数据生成器应（SHALL）为每个生成的联系人从默认 `contactIndustries` 中随机分配一个行业值。

#### 场景：生成的联系人具有行业
- **当（WHEN）** FakeRest 生成一个联系人
- **则（THEN）** 该联系人应拥有来自默认行业列表的有效行业 slug

### 需求：联系人汇总视图包含行业
`contacts_summary` 数据库视图应（SHALL）包含来自 `contacts` 表的 `industry` 字段。

#### 场景：查询 contacts_summary
- **当（WHEN）** 前端查询 `contacts_summary`
- **则（THEN）** 每行应包含该联系人的 `industry` 值

### 需求：联系人合并处理行业字段
联系人合并逻辑应（SHALL）处理 `industry` 字段。合并两个联系人时，应保留主联系人（被保留的）的行业值。

#### 场景：合并具有不同行业的联系人
- **当（WHEN）** 合并两个联系人，主联系人的 `industry` = `"energy"`，次联系人的 `industry` = `"financials"`
- **则（THEN）** 合并后的联系人应具有 `industry` = `"energy"`
