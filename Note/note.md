# Unity Shader学习笔记

## Day 01 初识Shader

### 着色器工作流

#### 几何阶段

1. **顶点着色器** （由开发者完全控制）
2. 曲面细分着色器 （部分控制）
3. 几何着色器 （部分控制， 调用硬件困难，并行程度低， 效率与顶点着色器有很大差距， 若非必要（例如顶点的增加、删除）， 请用顶点着色器）
4. 投影
5. 裁剪
6. 屏幕映射

#### 光栅化阶段

1. 图元组装（三角形设置）
2. 三角形遍历（形成片元）
3. **片元着色器** （完全控制）
4. 逐片元操作

### Unity 中的Shader 

#### 创建 Unlit Shader

1. frag 函数中， 返回的 col（fixed4）变量， 控制材质最终显示的颜色
2. 在Properties中设置参数， 用于显示在Unity中的控制面板上， 同时， 可以在Pass中设置同名参数， 用以获取这些变量
3. Tags 中的参数， Queue参数用于控制当前 **材质** 应当在哪个渲染队列中进行渲染， 以及可以控制相应的渲染优先级（通过提供渲染的偏移量）， 该变量可选参数如下。

| 名称 | 作用|
| --- | --- |
| Background | 最先渲染， 通常渲染背景 | 
| Geometry| 默认队列|
| AlphaTest| 渲染需要裁切的物体|
| Transparent| 渲染半透明的物体 |
| Overlay| 渲染叠加效果|
| 具体效果图  | P63， 表3-3|

#### 编写自己的cginc文件

作用： 类似于一个自己搭建的函数库， 其中包含了自己编写的常用函数， 或一些特效函数， 方便后续进行多次复用

例如：

~~~
half4 OnlyRedAlpha(half4 col)
{
    return half4(col.r, 0, 0, col.a);
}
~~~

## Day 02 认识Shader中的代码

### Shader中的结构体

语法：
struct 关键词
类似于 C/C++
其中的每个变量后都会带有一个 **: 描述字段** 用于描述该字段应当表示什么属性值

### 顶点着色器

就是其中的vert函数， 可以对顶点的一些信息进行修改

例如：
~~~
v2f vert (MyAppdata v)
{
    v2f o;
    // o.vertex = UnityObjectToClipPos(v.vertex);
    // o.vertex = UnityObjectToClipPos(v.vertex + float3(0, 1, 0)); // 并非修改了模型中顶点的位置， 这里的修改仅仅是 改变了物体的贴图显示的位置
    o.vertex = UnityObjectToClipPos(v.vertex + float3(0, _Offset, 0));
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    UNITY_TRANSFER_FOG(o,o.vertex);
    return o;
}
~~~

### 片元着色器

即 frag函数， 确定片元的颜色

### 常见的shader语言

1. GLSL
2. HLSL（推荐）
3. CG（Unity中现在默认的）

HLSL与CG语法相似， 某种意义上来说， CG是HLSL的变种， 所以， 掌握其中一种语言， 另一种语言的语法基本也就掌握了
